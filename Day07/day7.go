package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type FileNode struct {
	Name     string
	Size     int
	Children []FileNode
	parent   *FileNode
}

func (f *FileNode) AddChild(child FileNode) {
	f.Children = append(f.Children, child)
	f.Size += child.Size
	parent := f.parent
	for parent != nil {
		parent.Size += child.Size
		parent = parent.parent
	}
}

type State struct {
	currentDir  *FileNode
	root        *FileNode
	outputLines []string
	pos         int
}

func (s *State) AddDir(name string) {
	newDir := FileNode{Name: name, parent: s.currentDir}
	s.currentDir.AddChild(newDir)
}

func (s *State) AddFile(name string, size int) {
	newFile := FileNode{Name: name, Size: size, parent: s.currentDir}
	s.currentDir.AddChild(newFile)
}

func (s *State) HandleCd(name string) {
	if name == ".." {
		s.currentDir = s.currentDir.parent
		return
	}

	children := s.currentDir.Children
	for i := range children {
		if children[i].Name == name {
			s.currentDir = &children[i]
			return
		}
	}

	s.AddDir(name)
	s.currentDir = &s.currentDir.Children[len(s.currentDir.Children)-1]
}

func (s *State) HandleLs() {
	for s.pos < len(s.outputLines) && !strings.HasPrefix(s.outputLines[s.pos], "$") {
		line := strings.Split(s.outputLines[s.pos], " ")
		s.pos++
		name := line[1]

		if line[0] == "dir" {
			s.AddDir(name)
		} else {
			size, _ := strconv.Atoi(line[0])
			s.AddFile(name, size)
		}
	}
}

// Gets part stats for all nested directories recursively
func (s *State) dirStats(node FileNode, requiredSize int, minSize int) (int, int) {
	sum := 0

	if len(node.Children) == 0 {
		return 0, minSize
	}

	if node.Size >= requiredSize && node.Size < minSize {
		minSize = node.Size
	}

	if node.Size <= 100000 {
		sum += node.Size
	}

	for _, child := range node.Children {
		childSum, childMinSize := s.dirStats(child, requiredSize, minSize)
		sum += childSum
		if childMinSize < minSize {
			minSize = childMinSize
		}
	}

	return sum, minSize
}

func (s *State) Run() (int, int) {
	for s.pos < len(s.outputLines) {
		line := strings.Split(s.outputLines[s.pos], " ")
		s.pos++
		if line[1] == "cd" {
			s.HandleCd(line[2])
		} else {
			s.HandleLs()
		}
	}

	requiredSize := s.root.Size - 40000000
	return s.dirStats(*s.root, requiredSize, math.MaxInt)
}

func (s *State) printNode(node FileNode, depth int) {
	dirMarker := ""

	fmt.Printf("%s- %s %s (%d)\n", strings.Repeat("  ", depth), dirMarker, node.Name, node.Size)
	for _, child := range node.Children {
		s.printNode(child, depth+1)
	}
}

// Pretty prints all the files and directories in the tree
func (s *State) Print() {
	s.printNode(*s.root, 0)
}

func NewState(outputLines []string) State {
	root := FileNode{Name: "/"}
	return State{
		currentDir:  &root,
		root:        &root,
		outputLines: outputLines,
		pos:         1, // Skip the first line, cd /
	}
}

func main() {
	args := os.Args

	if len(args) != 2 {
		fmt.Println("Usage: day7.go <input>")
		return
	}

	file, err := os.Open(args[1])
	if err != nil {
		fmt.Println("Error opening file")
		return
	}

	scanner := bufio.NewScanner(file)
	var outputLines []string
	for scanner.Scan() {
		outputLines = append(outputLines, scanner.Text())
	}

	state := NewState(outputLines)
	sum, min := state.Run()
	state.Print()
	fmt.Println("Sum is", sum)
	fmt.Println("Min is", min)
}
